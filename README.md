# Tendable Coding Assessment

## Usage

```sh
bundle
ruby questionnaire.rb
```

## Goal

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

## Bonus Points

Updated readme with an explanation of your approach

Unit Tests

Code Comments

Dockerfile / Bash script if needed for us to run the exercise


## Approach

Prompting User for Answers:

1. The do_prompt method takes a store object as a parameter, which is an instance of PStore.
2. It iterates through each question defined in the QUESTIONS hash and prompts the user to answer each question.
3. The user's input is converted to lowercase and compared to 'yes' or 'y'. If it matches, 'Yes' is stored as the answer; otherwise, 'No' is stored.
4. After collecting all answers, they are stored in the PStore object using a transaction to ensure data consistency.

Calculating and Reporting Ratings:

1. The do_report method also takes the store object as a parameter.
2. It initializes variables total_yes and total_questions to calculate the rating for the current run.
3. Using a transaction, it iterates through each set of answers stored in the PStore object and calculates the total number of 'Yes' answers and the total number of questions.
4. The rating for the current run is calculated as the percentage of 'Yes' answers out of the total questions.
5. Similarly, it calculates the overall average rating by summing up the total number of 'Yes' answers across all runs and dividing it by the total number of  questions across all runs.
6. Both ratings are then printed to the console.

PStore Usage:

1. We use the PStore library to persist user answers between program runs. This ensures that the data is retained even if the program is closed or restarted.
2. PStore provides transaction support, ensuring that data integrity is maintained during read and write operations.

Execution Flow:
Finally, we create a new instance of PStore using the STORE_NAME, prompt the user for answers using do_prompt, and report the ratings using do_report.


## To run Unit Tests(rspec) 

```bash
# Run RSpec tests
rspec questionnaire_spec.rb
