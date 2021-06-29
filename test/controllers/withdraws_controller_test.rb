# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class WithdrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @withdraw = withdraws(:one)
  end

  test 'should get index' do
    get withdraws_url
    assert_response :success
  end

  test 'should get new' do
    get new_withdraw_url
    assert_response :success
  end

  test 'should create withdraw' do
    assert_difference('Withdraw.count') do
      post withdraws_url, params: { withdraw: {} }
    end

    assert_redirected_to withdraw_url(Withdraw.last)
  end

  test 'should show withdraw' do
    get withdraw_url(@withdraw)
    assert_response :success
  end

  test 'should get edit' do
    get edit_withdraw_url(@withdraw)
    assert_response :success
  end

  test 'should update withdraw' do
    patch withdraw_url(@withdraw), params: { withdraw: {} }
    assert_redirected_to withdraw_url(@withdraw)
  end

  test 'should destroy withdraw' do
    assert_difference('Withdraw.count', -1) do
      delete withdraw_url(@withdraw)
    end

    assert_redirected_to withdraws_url
  end
end
