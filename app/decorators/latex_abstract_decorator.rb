class LatexAbstractDecorator < Draper::Decorator
  def content
    # texto vazio, retornar mensagem genérica de texto vazio
    return I18n.t('empty_abstract') if object.nil? || object.content.nil? || object.content.empty?

    # .html_safe é essencial para evitar do & ser convertido para &amp;
    TccService.apply_latex(object.content).html_safe
  end

  def keywords
    # texto vazio, retornar mensagem genérica de texto vazio
    return I18n.t('empty_abstract_keywords') if object.nil? || object.keywords.nil? || object.content.empty?

    object.keywords
  end
end