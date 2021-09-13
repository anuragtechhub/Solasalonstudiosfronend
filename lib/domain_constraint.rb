class DomainConstraint
  def initialize(domains)
    @domains = (domains || "").split(",").map(&:strip)
  end

  def matches?(request)
    @domains.present? && @domains.any? { |o| /#{o}/ =~ request.host}
  end
end
