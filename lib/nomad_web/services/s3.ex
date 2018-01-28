defmodule NomadWeb.Services.S3 do
  alias NomadWeb.Services.PathCreator

  @one_week 60 * 60 * 24 * 7

  def bucket, do: Application.get_env(:nomad, :aws_bucket)
  def aws_host, do: Application.get_env(:nomad, :aws_host)

  def put_object(object, dest_path, opts \\ []) do
    %{status_code: status_code} =
      ExAws.S3.put_object(bucket(), dest_path, object, opts)
      |> ExAws.request!
    status_code
  end

  def put_object_acl(model, file_name, opts \\ []) do
    %{status_code: status_code} =
      ExAws.S3.put_object_acl(bucket(), PathCreator.file_path(model, file_name), opts)
      |> ExAws.request!
    status_code
  end

  def get_presigned_url(nil), do: "#"
  def get_presigned_url(dest_path) do
    {:ok, url} = ExAws.S3.presigned_url(ExAws.Config.new(:s3, [host: aws_host()]), :get, bucket(), dest_path, [expires_in: @one_week])
    url
  end

  def get_public_url(dest_path),
    do: "https://#{aws_host()}/#{bucket()}/#{dest_path}"

  def delete_object(%{image: nil}), do: nil
  def delete_object(entry) do
    bucket()
    |> ExAws.S3.delete_object(PathCreator.file_path(entry))
    |> ExAws.request!
  end

  def upload_to_s3(model, file_data, opts \\ [], s3_opts \\ [])
  def upload_to_s3(model, file_data, opts, s3_opts) do
    {:ok, file} = File.read(file_data.path)
    path = case opts do
      [] -> PathCreator.file_path(model, file_data.filename)
      opts -> PathCreator.file_path(model, file_data.filename, opts)
    end
    put_object(file, path, s3_opts)
    model
  end
end
