class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_role, only: [:new, :create, :edit, :update, :destroy]
  before_action :read_books, only: [:index]
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def create
    author_params = book_params[:author_attributes]
    if !author_params[:first_name].empty? && !author_params[:last_name].empty?
      # Create new author
      @author = Author.create(author_params)
    else
      # Use the selected author
      @author = Author.find(book_params[:author])
    end

    book = Book.create(title: book_params[:title], price: book_params[:price], genre_ids: book_params[:genres], author: @author)
    book.cover.attach(book_params[:cover])

    redirect_to book_path(book.id)
  end

  def new
    @book = Book.new
    @book.build_author
  end

  def edit
    @book.genres.build
  end

  def update
    author_params = book_params[:author_attributes]
    if !author_params[:first_name].empty? && !author_params[:last_name].empty?
      # Create new author if doesn't exist
      @author = Author.where(first_name: author_params[:first_name], last_name: author_params[:last_name]).first
      if @author.nil?
        @author = Author.create(author_params)
      end
    else
      # Use the selected author
      @author = Author.find(book_params[:author])
    end
    @book.update(title: book_params[:title], price: book_params[:price], genre_ids: book_params[:genres], author: @author)
    @book.cover.attach(book_params[:cover]) if book_params.has_key?(:cover)
    redirect_to @book
  end

  def destroy
	@book.destroy
	redirect_to root_path
  end

  private

  def read_books
    @books = Book.all
  end

  def set_book
    if params[:id]
      @book = Book.find(params[:id])
    end
  end

  def book_params
    params.require(:book).permit(:title, :cover, :price, :author, genres: [], author_attributes: [:first_name, :last_name])
  end

  def check_role
    if Book.new.can_edit? current_user
      return
    else
      flash[:alert] = "You are not authorised!"
      redirect_to root_path
    end
  end
end
