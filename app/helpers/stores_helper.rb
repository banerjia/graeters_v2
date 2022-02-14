module StoresHelper

    def store_address(store)
      state_code = nil

      return_value = store.addr_ln_1.strip.titlecase
      return_value += ', ' + store.addr_ln_2.strip.titlecase unless store.addr_ln_2.blank?
      return_value += ', ' + store.city
      begin
        state_code = store.state_code
      rescue
        state_code = store.state.state_code
      end

      return_value += ', ' + state_code
      return_value += '- ' + store.zip_code unless store.zip_code.blank?

      return return_value
    end

end
