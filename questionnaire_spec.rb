require 'rspec'
require_relative 'questionnaire'

RSpec.describe "Questionnaire" do
  before(:each) do
    @store_name = "test_store.pstore"
    @store = PStore.new(@store_name)
    @store.transaction do
      @store[:answers] = []
    end
  end

  after(:each) do
    File.delete(@store_name) if File.exist?(@store_name)
  end

  describe "do_prompt" do
    it "records user responses to questions" do
      allow_any_instance_of(Object).to receive(:gets).and_return("Yes", "No", "Yes", "No", "Yes")
      do_prompt(@store)
      @store.transaction(true) do
        answers = @store[:answers][-1]
        expect(answers["q1"]).to eq("Yes")
        expect(answers["q2"]).to eq("No")
        expect(answers["q3"]).to eq("Yes")
        expect(answers["q4"]).to eq("No")
        expect(answers["q5"]).to eq("Yes")
      end
    end
  end

  describe "do_report" do
    it "calculates the rating correctly" do
        @store.transaction do
          @store[:answers] = [
            {"q1" => "Yes", "q2" => "No", "q3" => "Yes", "q4" => "Yes", "q5" => "No"},
            {"q1" => "Yes", "q2" => "Yes", "q3" => "No", "q4" => "Yes", "q5" => "Yes"}
          ]
        end
        expect { do_report(@store) }.to output(/Rating for this run: 70%/).to_stdout
      end
      
      it "calculates the overall average rating correctly" do
        @store.transaction do
          @store[:answers] = [
            {"q1" => "Yes", "q2" => "No", "q3" => "Yes", "q4" => "Yes", "q5" => "No"},
            {"q1" => "Yes", "q2" => "Yes", "q3" => "No", "q4" => "Yes", "q5" => "Yes"}
          ]
        end
        expect { do_report(@store) }.to output(/Overall average rating: 70%/).to_stdout
      end
  end
end
