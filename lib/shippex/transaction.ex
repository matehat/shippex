defmodule Shippex.Transaction do
  @moduledoc false

  alias Shippex.{Transaction, Shipment, Rate, Label}

  @type t :: %Transaction{}

  @enforce_keys [:shipment, :rate, :label, :carrier]
  defstruct [:shipment, :rate, :label, :carrier]

  @spec transaction(Shipment.t(), Rate.t(), Label.t()) :: Transaction.t()
  def transaction(shipment, rate, label) do
    carrier = rate.service.carrier
    %Transaction{shipment: shipment, rate: rate, label: label, carrier: carrier}
  end
end
