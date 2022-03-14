require 'pod/poster/commands/generate'

RSpec.describe Pod::Poster::Commands::Generate do
  it "executes `generate` command successfully" do
    output = StringIO.new
    configName = nil
    options = {}
    command = Pod::Poster::Commands::Generate.new(configName, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
