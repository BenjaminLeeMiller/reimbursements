require 'reimbursement'

RSpec.describe Reimbursement do
  describe "#new" do
    let(:low_costs) { Costs::VALUES[Costs::LOW] }
    let(:high_costs) { Costs::VALUES[Costs::HIGH] }
    let(:project1_start_date) { Date.strptime('10/01/2024', '%m/%d/%Y') }
    let(:project1_end_date) { Date.strptime('10/03/2024', '%m/%d/%Y') }
    let(:project1) { Project.new(project1_start_date, project1_end_date, Costs::LOW) }
    let(:projects) { [project1] }
    let(:reimbursment) { described_class.new(projects)}

    context 'with only one project' do
      it 'should use travel for the start date and end dates' do
        [project1_start_date, project1_end_date].each do |travel_date|
          expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::TRAVEL_DAY)
        end
      end

      it 'should use full for the non-travel day' do
        expect(reimbursment.by_date[project1_end_date.prev_day][:day_type]).to eq(Costs::FULL_DAY)
      end

      it 'should calculate the total correctly' do
        count_full_days = (project1_start_date..project1_end_date).to_a.size - 2
        expected_total = 2 * low_costs[Costs::TRAVEL_DAY]
        expected_total += count_full_days * low_costs[Costs::FULL_DAY]

        expect(reimbursment.total).to eq(expected_total)
      end
    end

    context 'with mulitple projects' do
      let(:project2_end_date) { Date.strptime('10/10/2024', '%m/%d/%Y') }
      let(:project2_cost) { Costs::HIGH }
      let(:project2) { Project.new(project2_start_date, project2_end_date, project2_cost) }
      let(:projects) { [project1, project2] }

      context 'when there is a gap between them' do
        let(:project2_start_date) { Date.strptime('10/05/2024', '%m/%d/%Y') }

        it 'should use travel for the start date and end dates' do
          [
            project1_start_date, 
            project1_end_date,
            project2_start_date,
            project2_end_date
          ].each do |travel_date|
            expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::TRAVEL_DAY)
          end
        end

        it 'should calculate the total correctly' do
          count_low_full_days = (project1_start_date..project1_end_date).to_a.size - 2
          count_high_full_days = (project2_start_date..project2_end_date).to_a.size - 2
          expected_total = 2 * low_costs[Costs::TRAVEL_DAY]
          expected_total += 2 * high_costs[Costs::TRAVEL_DAY]
          expected_total += count_low_full_days * low_costs[Costs::FULL_DAY]
          expected_total += count_high_full_days * high_costs[Costs::FULL_DAY]

          expect(reimbursment.total).to eq(expected_total)
        end
      end

      context 'when there is no gap between them' do
        let(:project2_start_date) { Date.strptime('10/04/2024', '%m/%d/%Y') }

        it 'should use travel for the start date and end dates' do
          [project1_start_date, project2_end_date].each do |travel_date|
            expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::TRAVEL_DAY)
          end
        end

        it 'should use full day for  the end of project1 and start of project2' do
          [project2_start_date, project1_end_date].each do |travel_date|
            expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::FULL_DAY)
          end
        end

        it 'should calculate the total correctly' do
          count_low_full_days = (project1_start_date..project1_end_date).to_a.size - 1
          count_high_full_days = (project2_start_date..project2_end_date).to_a.size - 1
          expected_total = low_costs[Costs::TRAVEL_DAY]
          expected_total += high_costs[Costs::TRAVEL_DAY]
          expected_total += count_low_full_days * low_costs[Costs::FULL_DAY]
          expected_total += count_high_full_days * high_costs[Costs::FULL_DAY]

          expect(reimbursment.total).to eq(expected_total)
        end
      end

      context 'when they overlap' do
        context 'and have the same costs' do
          let(:project2_start_date) { Date.strptime('10/03/2024', '%m/%d/%Y') }
          let(:project2_cost) { Costs::LOW }

          it 'should use travel for the start date and end dates' do
            [project1_start_date, project2_end_date].each do |travel_date|
              expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::TRAVEL_DAY)
            end
          end

          it 'should use full day for  the end of project1 and start of project2' do
            [project2_start_date, project1_end_date].each do |travel_date|
              expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::FULL_DAY)
            end
          end

          it 'should calculate the total correctly' do
            count_low_full_days = (project1_start_date..project2_end_date).to_a.size - 2
            expected_total = 2 * low_costs[Costs::TRAVEL_DAY]
            expected_total += count_low_full_days * low_costs[Costs::FULL_DAY]

            expect(reimbursment.total).to eq(expected_total)
          end
        end

        context 'and have different costs' do
          let(:project2_start_date) { Date.strptime('10/03/2024', '%m/%d/%Y') }
          
          it 'should use travel for the start date and end dates' do
            [project1_start_date, project2_end_date].each do |travel_date|
              expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::TRAVEL_DAY)
            end
          end

          it 'should use full day for  the end of project1 and start of project2' do
            [project2_start_date, project1_end_date].each do |travel_date|
              expect(reimbursment.by_date[travel_date][:day_type]).to eq(Costs::FULL_DAY)
            end
          end

          it 'should calculate the total correctly' do
            # Note: the overlapping days will be included as higher cost
            count_low_full_days = (project1_start_date..project2_start_date).to_a.size - 2
            # Note: the first day of high project would be counted as full due to overlap
            count_high_full_days = (project2_start_date..project2_end_date).to_a.size - 1
            expected_total = low_costs[Costs::TRAVEL_DAY]
            expected_total += high_costs[Costs::TRAVEL_DAY]
            expected_total += count_low_full_days * low_costs[Costs::FULL_DAY]
            expected_total += count_high_full_days * high_costs[Costs::FULL_DAY]

            expect(reimbursment.total).to eq(expected_total)
          end
        end
      end

    end

    context 'when the arguement is not an array' do
      it 'should raise InvalidProjects' do
        expect { described_class.new('not an array') }.to raise_error(described_class::InvalidProjects)
      end

      context 'of Project objects' do
        it 'should raise InvalidProjects' do
          expect { described_class.new(['not an array']) }.to raise_error(described_class::InvalidProjects)
        end
      end
    end
  end
end
