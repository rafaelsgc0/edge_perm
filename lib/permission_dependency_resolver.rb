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

  # @param [existing] Array with user current permissions
  # @param [perm_to_be_denied] String Permission to be denied
  # @return [Boolean] If the permission given can be granted.
  # raise an error if the permission existing has an error of dependencies.
  def can_deny?(existing, perm_to_be_denied)
    can_go = current_dependencies_fine?(existing)
    raise InvalidBasePermissionsError, 'you current permissions are wrong' unless can_go

    # it is good to go if the permission to be deny is not a dependency
    # any existing one
    existing.map { |d| @dependencies[d].include?(perm_to_be_denied) }.none?
  end

  # @param [existing] Array with user current permissions
  #  @return [Array] Array with the the permissions given
  # sorted by the dependencies.
  def sort(permissions)
    # remove the permissions from the dependencies
    # that we don't need
    only_given_depen = @dependencies.slice(*permissions)
    permission_convert = []

    #create an array of hashes with the values given
    only_given_depen.each do |key, value|
      permission_convert += [perm: key, dep: value]
    end

    # sort the array by dep
    permission_convert.sort! do |a, b|
      k = (b[:dep] <=> b[:dep])
      k.zero? ? b[:perm] <=> a[:perm] : k
    end

     permission_convert.map{|node| node[:perm] }

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
