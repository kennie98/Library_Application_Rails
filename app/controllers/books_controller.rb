class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @books_return = @books
    @genre_id = params[:genre_id]
    if (@genre_id == '1')
      @books_return = @books.find_all {|b| b.genre == 'hardcover-fiction'}
    elsif (@genre_id == '2')
      @books_return = @books.find_all {|b| b.genre == 'hardcover-nonfiction'}
    else
      @books_return = @books.find_all {|b| b.genre == 'animals'}
    end


  end

  # GET /books/1
  # GET /books/1.json
  def show

  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit

  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def favorite
    @book = Book.find(params[:id])
    type = params[:type]
    if type == "favorite"
      current_user.favorites << @book
      redirect_to root_path, notice: "You favorited #{@book.title}"
    elsif type == "unfavorite"
      current_user.favorites.delete(@book)
      redirect_to root_path, notice: "Unfavorited #{@book.title}"
    else
      redirect_to root_path, notice: "All good."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author)
    end
end
