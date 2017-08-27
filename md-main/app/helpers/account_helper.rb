module AccountHelper
  def render_by_opertation_type(transaction)
    if transaction.reason_type == 'ExternalTransaction'
      partial = 'accounts/refill'
    else
      partial = case transaction.reason.purchase.product.product_type
                when 'cert' then 'accounts/dream_certificate'
                when 'vip' then 'accounts/vip'
                when 'special' then 'accounts/coin_gift'
                end
    end

    render partial: partial, locals: { transaction: transaction }
  end
end
