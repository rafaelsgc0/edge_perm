require 'tsort' # HINT

class PermissionDependencyResolver

  def initialize(dependencies)
    @dependencies = dependencies
  end

  # @param [Array] array with user current permissions
  # @param [String] Permission to be granted
  # @return [Boolean] If the permission given can be granted.
  def can_grant?(existing, perm_to_be_granted)
    dependencies_to_check = @dependencies[perm_to_be_granted]
    dependencies_to_check.index { |x| !existing.include?(x) }.nil?
  end

  def can_deny?(existing, perm_to_be_denied)

  end

  def sort(permissions)

  end
end
