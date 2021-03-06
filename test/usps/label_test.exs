defmodule Shippex.USPS.LabelTest do
  use ExUnit.Case

  describe "domestic" do
    test "priority label generated" do
      Helper.valid_shipment
      |> test_shipment(:usps_priority)
    end

    test "priority express label generated" do
      Helper.valid_shipment
      |> test_shipment(:usps_priority_express)
    end

    test "insured priority label generated" do
      Helper.valid_shipment(insurance: 500_00)
      |> test_shipment(:usps_priority)
    end

    test "insured priority express label generated" do
      Helper.valid_shipment(insurance: 500_00)
      |> test_shipment(:usps_priority_express)
    end
  end

  describe "canada" do
    test "priority label generated for canada" do
      Helper.valid_shipment(to: "CA")
      |> test_shipment(:usps_priority)
    end

    test "priority express label generated for canada" do
      Helper.valid_shipment(to: "CA")
      |> test_shipment(:usps_priority_express)
    end

    test "insured priority label generated for canada" do
      Helper.valid_shipment(to: "CA", insurance: 500_00)
      |> test_shipment(:usps_priority)
    end

    test "insured priority express label generated for canada" do
      Helper.valid_shipment(to: "CA", insurance: 500_00)
      |> test_shipment(:usps_priority_express)
    end
  end

  describe "mexico" do
    test "priority label generated for mexico" do
      Helper.valid_shipment(to: "MX", insurance: nil)
      |> test_shipment(:usps_priority)
    end

    test "priority express label generated for mexico" do
      Helper.valid_shipment(to: "MX", insurance: nil)
      |> test_shipment(:usps_priority_express)
    end
  end

  defp test_shipment(shipment, service) do
    expected_line_items = if shipment.package.insurance, do: 2, else: 1

    {:ok, rate} = Shippex.Carrier.USPS.fetch_rate(shipment, service)
    assert length(rate.line_items) == expected_line_items

    {:ok, transaction} = Shippex.Carrier.USPS.create_transaction(shipment, rate.service)
    assert length(transaction.rate.line_items) == expected_line_items
  end
end
