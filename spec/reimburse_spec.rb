
RSpec.describe "Output from command line" do
  describe "For sample1.json" do
    it "should return the correct total" do
      actual_output = `ruby reimburse.rb examples/sample1.json`
      expect(actual_output).to include('Total Reimbursement: 240')
    end
  end

  describe "For sample2.json" do
    it "should return the correct total" do
      actual_output = `ruby reimburse.rb examples/sample2.json`
      expect(actual_output).to include('Total Reimbursement: 665')
    end
  end

  describe "For sample3.json" do
    it "should return the correct total" do
      actual_output = `ruby reimburse.rb examples/sample3.json`
      expect(actual_output).to include('Total Reimbursement: 520')
    end
  end

  describe "For sample4.json" do
    it "should return the correct total" do
      actual_output = `ruby reimburse.rb examples/sample4.json`
      expect(actual_output).to include('Total Reimbursement: 440')
    end
  end
end