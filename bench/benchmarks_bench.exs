defmodule BenchmarksBench do

  @test_file  "/tmp/#{__MODULE__}.bench"

  use Benchfella
  require Mongo.Bang
  require BenchMacros

  setup_all do
    agent = Repox.start :normal, []
    {:ok, agent}
  end

  bench "100x put to a Mongo collection", [gw: gen_mongo_gw()] do
    BenchMacros.add_to_gateway(gw, 100)
  end

  bench "100x put to a File List", [gw: gen_file_gw] do
    BenchMacros.add_to_gateway(gw, 100)
  end

  bench "100x put to a Memory List", [gw: gen_list_gw] do
    BenchMacros.add_to_gateway(gw, 100)
  end

  defp gen_list_gw do %ListGateway{} end
  defp gen_file_gw do %FileGateway{path: @test_file} end
  defp gen_mongo_gw do
    mongo = Repox.config(:mongo)
    %MongoDBGateway{
      db: "bench", collection: "bench_collection", mongo: mongo
    }
  end

end
