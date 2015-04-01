require "rest_client"
require "viggles/version"
require "openssl"
require "base64"

module Viggles

  class Api

    def initialize(params = {})
      @key = params[:key]
      @token = params[:token]
      @secret = params[:secret]
      @api = RestClient::Resource.new('https://sapi-stage.choosedigital.com')
      # @api = RestClient::Resource.new('http://requestb.in/1a8yhns1')
    end

    def token
      response = @api['token'].get headers
      # result = @api.get headers # for the requestb.in endpoint for testing
      JSON.parse(response).tap do |data|
        if data['success'] == true
          @token = data['token']
        end
      end
    end

    ##
    # User Endpoints
    ##

    def register(viggle_member_id)
      params = {
        token: @token,
        viggleMemberId: viggle_member_id,
        authentication: auth(@token + viggle_member_id)
      }

      begin
        response = @api['register'].post params.to_json, headers
      rescue => e
        response = e.response
      end

      JSON.parse(response)
    end

    # when you don't pass a parameter, it calls the "sanity check" user endpoint
    def user(viggle_member_id = nil)
      user_api = @api['user']
      params = nil

      if viggle_member_id
        user_api = user_api[viggle_member_id]
      end

      begin
        response = user_api.get headers
      rescue => e
        response = e.response
      end

      JSON.parse(response)
    end

    # @param viggle_member_id [String] required
    # @param params [Hash] user profile data to send to Viggle
    def update(params = {})
      params.merge({
        token: @token,
        memberId: params[:memberId],
        authentication: auth(@token + params[:memberId])
      })

      begin
        response = @api['update'].post params.to_json, headers
      rescue => e
        response = e.response
      end

      JSON.parse(response)
    end

    ##
    # Points Endpoints
    ##

    def deposit(params = {})
      params = {
        token: @token,
        authentication: auth(@token + params[:viggleMemberId] + params[:pointsToDeposit].to_s + params[:partnerTransactionId] + params[:campaign] + params[:transactionType] + params[:actionType])
      }.merge(params)

      begin
        @api['deposit'].post params.to_json, headers
      rescue => e
        response = e.response
      end

      JSON.parse(response)
    end

    # def withdraw(viggle_member_id, params = {})
    #   params = {
    #     token: @token,
    #     viggleMemberId: viggle_member_id,
    #     authentication: auth(viggle_member_id + params[:pointsToDeposit] + params[:partnerTransactionId] + params[:campaign] + params[:transactionType] + params[:actionType])
    #   }.merge(params)
    #
    #   begin
    #     @api['withdraw'].post params.to_json, headers
    #   rescue => e
    #     response = e.response
    #   end
    #
    #   JSON.parse(response)
    # end

    private

    ##
    # Utilities
    ##

    def headers
      auth_date = Time.now.utc.iso8601
      {
        'x-access-key' => @key,
        'x-authorization-date' => auth_date,
        'x-authorization' => auth(auth_date),
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def auth(string)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), @secret, string)).chomp
    end

  end # class Api

end
