use utf8;
package Schema::Result::User2session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::User2session

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user2session>

=cut

__PACKAGE__->table("user2session");

=head1 ACCESSORS

=head2 session

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 ip

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 confirm

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 user_agent_md5

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 user_agent

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "session",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "ip",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "confirm",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "user_agent_md5",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "user_agent",
  { data_type => "varchar", is_nullable => 0, size => 500 },
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

=item * L</session>

=back

=cut

__PACKAGE__->set_primary_key("session");

=head1 UNIQUE CONSTRAINTS

=head2 C<session_UNIQUE>

=over 4

=item * L</session>

=item * L</user_id>

=item * L</ip>

=item * L</user_agent_md5>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "session_UNIQUE",
  ["session", "user_id", "ip", "user_agent_md5"],
);

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-06-30 14:26:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Lonyhi9EEV4kLu8ZWXSqHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
