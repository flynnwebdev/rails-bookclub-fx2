class OrdersController < ApplicationController
  def new
    @book = Book.find(params[:book_id])

    Stripe.api_key = ENV['STRIPE_SK_TEST']
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      success_url: order_success_url,
      cancel_url: order_cancel_url,
      line_items: [
        {
          name: @book.title,
          description: "by #{@book.author.name}",
          images: @book.cover.attached? ? [@book.cover.service_url] : [],
          amount: (@book.price * 100).to_i,
          currency: 'aud',
          quantity: 1
        }
      ]
    )
  end

  def success
    render html: "<h4>Thanks for your order!</h4>"
  end

  def cancel
    render html: "<h4>The order was cancelled.</h4>"
  end
end
