require 'spec_helper'

describe 'ArticleRef' do

  let(:attributes) { Fabricate.attributes_for(:article_ref) }
  let(:article_ref) { Fabricate(:article_ref) }

  before do
    page.set_rack_session(fake_lti_session)
  end

  context 'creates an article reference with success' do
    it '/new' do
      visit new_article_ref_path
      fill_in 'Segundo Autor', :with => attributes[:second_author]
      fill_in 'Título do Artigo', :with => attributes[:article_title]
      click_button I18n.t(:'formtastic.actions.create', model: I18n.t(:'activerecord.models.article_ref'))
      expect(page).to have_content(:success)
    end
  end

  context 'edit a book reference with success' do
    it '/edit' do
      get edit_book_ref_path(article_ref.id)
      click_link 'Edit'
      expect(response.status).to be(200)
    end
  end

  context 'destroy a book cap reference' do
    it '/destroy' do
      delete article_ref_path(article_ref.id)
      expect(response.status).to be(200)
    end
  end

  context 'update a book cap reference' do
    it '/update' do
      put article_ref_path(article_ref.id)
      expect(response.status).to be(200)
    end
  end

end
