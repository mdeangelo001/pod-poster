RSpec.describe "`pod-poster generate` command", type: :cli do
  it "executes `pod-poster help generate` command successfully" do
    output = `pod-poster help generate`
    expected_output = <<-OUT
Usage:
  pod-poster generate [CONFIGNAME]

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
