require "pstore"

STORE_NAME = "tendable.pstore"
QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

def do_prompt(store)
  answers = {}
  QUESTIONS.each_key do |question_key|
    print QUESTIONS[question_key]
    ans = gets.chomp.downcase
    # Store user's answer
    answers[question_key] = (ans == 'yes' || ans == 'y') ? 'Yes' : ((ans == 'no' || ans == 'n') ? 'No' : 'Invalid Input')
  end
  # Store answers in PStore
  store.transaction do
    store[:answers] ||= []
    store[:answers] << answers
  end
end

def do_report(store)
  total_yes = 0
  total_questions = 0
  # Calculate rating for each run
  store.transaction(true) do
    store[:answers]&.each do |answers|
      total_yes += answers.values.count('Yes')
      total_questions += QUESTIONS.size
    end
  end
  rating = total_yes * 100 / total_questions
  puts "Rating for this run: #{rating}%"
  
  # Calculate overall average rating
  overall_total_yes = 0
  overall_total_questions = 0
  store.transaction(true) do
    store[:answers]&.each do |answers|
      overall_total_yes += answers.values.count('Yes')
      overall_total_questions += QUESTIONS.size
    end
  end
  overall_rating = overall_total_yes * 100 / overall_total_questions
  puts "Overall average rating: #{overall_rating}%"
end

store = PStore.new(STORE_NAME)
do_prompt(store)
do_report(store)
