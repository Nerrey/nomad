defmodule NomadWeb.Services.PathCreator do

  def file_path(nil), do: nil
  def file_path(%{image: nil} = model), do: nil
  def file_path(model), do: file_path(model, Path.basename(model.image))
  def file_path(model, file_name), do:
    "#{file_path_builder(model)}/#{model.id}/#{file_name_wo_spaces(file_name)}"

  def file_path_builder(model), do: model.__struct__.__schema__(:source)

  def file_name_wo_spaces(file_name), do: String.replace(file_name, " ", "_")
end
