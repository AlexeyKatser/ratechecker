class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]
  before_action :set_last_rate, only: [:index]

  # GET /currencies
  # GET /currencies.json

  def index
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # POST /currencies
  # POST /currencies.json
  def create
    @currency = Currency.new(currency_params)
    @currency.date = date_from_params(params, :date).in_time_zone('Moscow') unless params[:currency][:date].nil?
    p @currency.date
    respond_to do |format|
      if @currency.save
        format.html do 
          flash.notice = 'Currency was successfully created.' 
          redirect_to admin_path
        end
        format.js do 
          flash.notice = 'Currency was successfully added' 
          render template: '/currencies/rate-table.js', layout: false, content_type: 'text/javascript'
        end
      else
        format.html { render :new }
        format.js { render action: 'new' }
      end
    end
  end

  private
    def set_last_rate
      @last_rate = Currency.last
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(:value, :added_by, :date)
    end

  # Преобразование даты и времени в нормальный вид
  def date_from_params(params, date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
    date_array = params.values_at(*date_keys).map(&:to_i)
    Date.civil(*date_array)
  end   
end
