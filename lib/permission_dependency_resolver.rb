require 'tsort' # HINT

class PermissionDependencyResolver

  def initialize(dependencies)
    @dependencies = dependencies
  end

  # @param [existing] Array with user current permissions
  # @param [perm_to_be_granted] String - Permission to be granted
  # @return [Boolean] If the permission given can be granted.
  # raise an error if the permission existing has an error of dependencies.
  def can_grant?(existing, perm_to_be_granted)
    can_go = current_dependencies_fine?(existing)
    raise InvalidBasePermissionsError, 'Cannot grant because your current permissions are wrong' unless can_go

    dependencies_to_check = @dependencies[perm_to_be_granted]
    dependencies_to_check.index { |x| !existing.include?(x) }.nil?
  end

  def can_deny?(existing, perm_to_be_denied)

  end

  def sort(permissions)

  end

  private

  # @param [existing] Array with user current permissions
  # @return [Boolean] If the current permissions
  # have all the dependencies correct.
  def current_dependencies_fine?(existing)
    my_dep = []
    existing.each { |d| my_dep += @dependencies[d] }
    result = my_dep - existing

    result.empty?
  end
end
