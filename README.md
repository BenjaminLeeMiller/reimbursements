# Reimbursements

Calculates reimbursement for projects taking into account city cost and work day type.

## The rules for reimbursement are as follows:

- Any given day is only ever reimbursed once, even if multiple projects are on the same day.
- Projects that are contiguous or overlap, with no gap between the end of one and the start of the next, are considered a sequence of projects and should be treated similar to a single project.
- First day and last day of a project (or sequence of projects) are travel days.
- Any day in the middle of a project (or sequence of projects) is considered a full day.
- If there is a gap between projects, those gap days are not reimbursed and the days on either side of that gap are travel days.
- A travel day is reimbursed at a rate of 45 dollars per day in a low cost city.
- A travel day is reimbursed at a rate of 55 dollars per day in a high cost city.
- A full day is reimbursed at a rate of 75 dollars per day in a low cost city.
- A full day is reimbursed at a rate of 85 dollars per day in a high cost city.

Note: An assumption has been made that if more than one city cost can apply to a single day, the higher value will be used.

## Usage
1. Checkout the code and navigate to the project folder
2. Run `bundle install`
3. Rub `bundle exec rspec`
4. Run `bundle exec ruby reimburse.rb examples/sample1.json`

## Creating your own projects JSON.

To create a projects JSON, you need to adhere to the following:
```json
{
  "projects" : [
    { "start_date" : "10/01/2024", "end_date" : "10/04/2024", "cost" : "low" },
    ...
  ]
}
```

Dates have the format of `mm/dd/yyyy`
Valid values for cost are `high` or `low`
