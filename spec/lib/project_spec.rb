require 'project'

RSpec.describe Project do
  describe "#new" do
    let(:start_date) { Date.new }
    let(:end_date) { Date.new }
    let(:cost) { Costs::LOW }

    subject { described_class.new(start_date, end_date, cost) }

    context "with valid params" do
      it 'should return a new instance.' do
        expect(subject).to be_a described_class
      end
    end

    context "when the start date is" do
      context "not a date" do
        let(:start_date) { "Not a Date" }

        it 'should raise InvalidStartDate' do
          expect { subject }.to raise_error(Project::InvalidStartDate)
        end
      end

      context "after the end date" do
        let(:start_date) { Date.new.next_day }

        it 'should raise InvalidDateRange' do
          expect { subject }.to raise_error(Project::InvalidDateRange)
        end
      end
    end

    context "when the end date is not a date" do
      let(:end_date) { "Not a Date" }

      it 'should raise InvalidEndDate' do
        expect { subject }.to raise_error(Project::InvalidEndDate)
      end
    end

    context "when the cost is invalid" do
      let(:cost) { "bob" }

      it 'should raise InvalidCost' do
        expect { subject }.to raise_error(Project::InvalidCost)
      end
    end
  end
end