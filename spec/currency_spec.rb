require 'rails_helper'
include CurrenciesHelper
require 'sidekiq/testing' 

RSpec.describe Currency do
	Sidekiq::Testing.fake!

	describe '#Currency' do
		let! (:rate) {Currency.new value: 50.55, added_by: 1, date: '3019/12/22 14:24'}

		it 'value must be a valid number' do
			expect(rate.value).to be_a_kind_of(Numeric) 
		end

		it 'value must be in range 0.0001...10000' do
			expect(rate.value).to be_between(0.0001, 10000)
		end

		subject {rate.save!}

		it 'save must broadcast' do
			expect { subject }.to have_broadcasted_to('rate_notifications_channel').with(rvalue: "<h2 class='text-center text-primary'>#{rate.value} ₽</h2>")
		end	

		it 'something' do
			expect(Sidekiq.get_schedule.to_h['stopAdminRate']['at']).to eq('3019/12/22 14:24:00')
		end

	end

	it 'must get rate from url or return nil' do
		expect(getCurrentRateFromSite).to be_a_kind_of(Numeric).or eq(nil)
	end

	it 'must save rate to DB' do
		saveRateToDB 60
		expect(Currency.last).not_to be_nil
	end

	it 'dont save non numeric values' do
		expect { saveRateToDB('trash!') }.to raise_error ActiveRecord::RecordInvalid
	end

	it 'dont save dates in the past' do
		rate = Currency.new value: 50.55, added_by: 1, date: '1019/12/22 14:24'
		expect { rate.save! }.to raise_error ActiveRecord::RecordInvalid
	end

	it 'must start cron job' do
		expect { RateWorker.perform_async(1, 2) }.to change(RateWorker.jobs, :size).by(1)
	end

	it 'must add a new admin job' do
		expect { AdminWorker.perform_async(1,2) }.to change(AdminWorker.jobs, :size).by(1)
	end

end