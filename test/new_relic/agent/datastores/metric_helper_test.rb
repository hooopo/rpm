# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','test_helper'))
require 'new_relic/agent/datastores/metric_helper'

class NewRelic::Agent::Datastores::MetricHelperTest < Minitest::Test
  def setup
    @product = "JonanDB"
    @collection = "wiggles"
    @operation = "select"
  end

  def test_statement_metric_for
    expected = "Datastore/statement/JonanDB/wiggles/select"
    result = NewRelic::Agent::Datastores::MetricHelper.statement_metric_for(@product, @collection, @operation)
    assert_equal expected, result
  end

  def test_operation_metric_for
    expected = "Datastore/operation/JonanDB/select"
    result = NewRelic::Agent::Datastores::MetricHelper.operation_metric_for(@product, @operation)
    assert_equal expected, result
  end

  def test_context_metric_returns_web_for_web_context
    NewRelic::Agent::Transaction.stubs(:recording_web_transaction?).returns(true)
    expected = "Datastore/allWeb"
    result = NewRelic::Agent::Datastores::MetricHelper.context_metric
    assert_equal expected, result
  end

  def test_context_metric_returns_other_for_non_web_context
    NewRelic::Agent::Transaction.stubs(:recording_web_transaction?).returns(false)
    expected = "Datastore/allOther"
    result = NewRelic::Agent::Datastores::MetricHelper.context_metric
    assert_equal expected, result
  end

  def test_metrics_for_in_web_context
    NewRelic::Agent::Transaction.stubs(:recording_web_transaction?).returns(true)
    expected = [
      "Datastore/all",
      "Datastore/allWeb",
      "Datastore/statement/JonanDB/wiggles/select",
      "Datastore/operation/JonanDB/select"
    ]

    result = NewRelic::Agent::Datastores::MetricHelper.metrics_for(@product, @collection, @operation)
    assert_equal expected, result
  end

  def test_metrics_for_outside_web_context
    NewRelic::Agent::Transaction.stubs(:recording_web_transaction?).returns(false)
    expected = [
      "Datastore/all",
      "Datastore/allOther",
      "Datastore/statement/JonanDB/wiggles/select",
      "Datastore/operation/JonanDB/select"
    ]

    result = NewRelic::Agent::Datastores::MetricHelper.metrics_for(@product, @collection, @operation)
    assert_equal expected, result
  end

  def test_metric_from_activerecord_name
    names = {
      "Wiggles Load" => "Datastore/Wiggles/find",
      "Wiggles Count" => "Datastore/Wiggles/find",
      "Wiggles Exists" => "Datastore/Wiggles/find",
      "Wiggles Indexes" => nil,
      "Wiggles Columns" => nil,
      "Wiggles Destroy" => "Datastore/Wiggles/destroy",
      "Wiggles Find" => "Datastore/Wiggles/find",
      "Wiggles Save" => "Datastore/Wiggles/save",
      "Wiggles Create" => "Datastore/Wiggles/create",
      "Wiggles Update" => "Datastore/Wiggles/save",
      "Join Find" => "Datastore/Wiggles/find"
    }

    names.each do |name, metric|
      result = ARHelperTest.
      assert_equal
    end
  end
end
