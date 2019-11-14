require 'rails_helper'
include CurrenciesHelper
require 'sidekiq/testing' 

RSpec.describe Currency do
	describe '#Currency' do
		let! (:rate) {Currency.new value: 50.55, added_by: 1}

		it 'value must be a valid number' do
			expect(rate.value).to be_a_kind_of(Numeric) 
		end

		it 'value must be in range 0.0001...10000' do
			expect(rate.value).to be_between(0.0001, 10000)
		end
		it 'must broadcast value on save' do
			expect { rate.save! }.to have_broadcasted_to('rate_notifications_channel').with(rvalue: "<h2 class='text-center'>#{rate.value}</h2>")
		end		
	end

	it 'must get rate from url or return nil' do
		expect(getCurrentRateFromSite).to be_a_kind_of(Numeric).or eq(nil)
	end

	it 'must save rate to DB' do
		saveRateToDB 60
		expect(Currency.last).not_to be_nil
	end

	it 'dont save trash do DB' do
		expect { saveRateToDB('trash!') }.to raise_error ActiveRecord::RecordInvalid
	end

	it 'must start job' do
		Sidekiq::Testing.fake!
		expect { RateWorker.perform_async(1, 2) }.to change(RateWorker.jobs, :size).by(1)
	end
end