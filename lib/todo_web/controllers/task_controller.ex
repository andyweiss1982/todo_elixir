defmodule TodoWeb.TaskController do
  use TodoWeb, :controller
  alias Todo.{Task, Repo}

  def index(conn, _params) do
    changeset = Task.changeset(%Task{}, %{})
    tasks = Repo.all(Task)
    render conn, "index.html", changeset: changeset, tasks: tasks
  end

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)

    conn = case Repo.insert(changeset) do
      {:ok, _model} ->
        conn
        |> put_flash(:info, "Task successfully created")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not create task")
    end

    redirect conn, to: task_path(conn, :index)
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get(Task, id)
    Repo.delete(task)
    conn
    |> put_flash(:info, "Task successfully deleted")
    |> redirect(to: task_path(conn, :index))
  end
end
