defmodule Changelog.PodcastChannel do
  use Changelog.Data

  alias Changelog.{Channel, Podcast}

  schema "podcast_channels" do
    field :position, :integer
    field :delete, :boolean, virtual: true

    belongs_to :podcast, Podcast
    belongs_to :channel, Channel

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(position podcast_id channel_id delete))
    |> validate_required([:position])
    |> mark_for_deletion()
  end

  def by_position do
    from p in __MODULE__, order_by: p.position
  end

  defp mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
