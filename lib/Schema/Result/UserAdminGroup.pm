use utf8;
package Schema::Result::UserAdminGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::UserAdminGroup

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_admin_group>

=cut

__PACKAGE__->table("user_admin_group");

=head1 ACCESSORS

=head2 user_admin_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_admin_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_admin_group_id>

=back

=cut

__PACKAGE__->set_primary_key("user_admin_group_id");

=head1 RELATIONS

=head2 user2admins

Type: has_many

Related object: L<Schema::Result::User2admin>

=cut

__PACKAGE__->has_many(
  "user2admins",
  "Schema::Result::User2admin",
  { "foreign.user_admin_group_id" => "self.user_admin_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fTAo3x6SMeFAvoXVT6rZJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
