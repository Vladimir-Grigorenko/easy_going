use utf8;
package Schema::Result::Supplier2manager;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Supplier2manager

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<supplier2manager>

=cut

__PACKAGE__->table("supplier2manager");

=head1 ACCESSORS

=head2 supplier2manager_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 supplier_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 manager_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "supplier2manager_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "supplier_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "manager_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
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

=item * L</supplier2manager_id>

=back

=cut

__PACKAGE__->set_primary_key("supplier2manager_id");

=head1 RELATIONS

=head2 manager

Type: belongs_to

Related object: L<Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "manager",
  "Schema::Result::User",
  { user_id => "manager_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 supplier

Type: belongs_to

Related object: L<Schema::Result::Supplier>

=cut

__PACKAGE__->belongs_to(
  "supplier",
  "Schema::Result::Supplier",
  { supplier_id => "supplier_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-08-17 13:54:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:92zTIa+hgqn/OE+bdXkvAQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
