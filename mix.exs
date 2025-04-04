defmodule RabbitMQCloudWatchExporter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rabbitmq_cloudwatch_exporter,
      version: get_version(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      deps_path: System.get_env("DEPS_DIR", "deps"),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:rabbit, :mnesia, :singleton],
      mod: {RabbitMQCloudWatchExporter, []}
    ]
  end

  # Get version directly from git tag
  defp get_version do
    {tag, 0} = System.cmd("git", ["describe", "--tags", "--abbrev=0"], stderr_to_stdout: true)
    tag
    |> String.trim()
    |> String.replace_prefix("v", "") 
  end

  defp deps() do
    [
      {:ex_aws, "~> 2.5.7"},
      {:ex_aws_cloudwatch, "~> 2.0.4"},
      {:singleton, "~> 1.4.0"},
      {:jason, "~> 1.4.4"},
      {:decimal, "~> 2.0"},
      {:hackney, "~> 1.20.1"},
      {:sweet_xml, "~> 0.6"},
      {:configparser_ex, "~> 4.0"},
      {:req, "~> 0.5.10"},
      {:castore, "~> 1.0"},
      {:brotli, "~> 0.3"},
      {:ezstd, "~> 1.0"},
      {:nimble_csv, "~> 1.2"},
      {:plug, "~> 1.0"},
      {:mime, "~> 2.0.6"},
      {:finch, "~> 0.17"},
      {:mix_task_archive_deps, github: "noxdafox/mix_task_archive_deps"}
    ]
  end

  defp archive_dir do
    System.get_env("ARCHIVE_DIR", "plugins")
  end
  
  defp aliases do
    [
      make_deps: [
        "deps.get",
        "deps.compile"
      ],
      make_app: [
        "deps.get",
        "deps.compile",
        "compile"
      ],
      make_archives: [
        "archive.build.deps --destination=#{archive_dir()}",
        "archive.build.elixir --destination=#{archive_dir()}",
        "archive.build.all --destination=#{archive_dir()}"
      ]
    ]
  end
end
