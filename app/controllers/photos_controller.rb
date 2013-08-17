class PhotosController < ApplicationController

  before_action :require_current_user, except: [:show,:search]

  def index  
      @photos = Photo.all
  

    # puts "Photos = #{@photos.class}, #{@photos.inspect}"
    @photo_titles = @photos.collect { |photo| photo.title } 
    respond_to do |format|  
      format.json { render :json => @photos.to_json }
      format.text { render :text => @photo_titles }
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = @current_user
    if @photo.save
      UserMailer.new_photo_email(@current_user).deliver
      redirect_to photo_path(@photo)
    else
      redirect_to new_photo_path, notice: "You've entered invalid parameters, please try again"
    end
  end

  def buy #STRIPE: public action b/c it has as URL that routes to it (route file)
    #create a stripe customer object using email they entered in form. 
    customer = Stripe::Customer.create(
      email: params[:email], #STRIPE's code - stripe docs
      card: params[:stripeToken] #STRIPE's code - stripe docs -- stripe gives us tokens for credit card
      )
    #create a new charge to the customer's credit card for the given amount and currency
    Stripe::Charge.create(
      :customer => customer.id,
      :amount => @photo.price,
      :description => 'Rails Stripe Customer',
      :currency => 'cad'
    )

    #if the charge fails - ie. credit card maxed out, wrong cc number, etc.
    #stripe to send us an error if charge fails - rescue lets us catch an error
    rescue Stripe::CardError => error
      flash[:error] = error.message
      redirect_to photo_path(params[:id]) #url has photo in it so can get id from it as well
  end

  def search
    @results = Photo.search_for params[:query]
  end

  private #when in private, no url for it

  def photo_params
    params.require(:photo).permit(:title,:description,:upload, :price)
  end
end
