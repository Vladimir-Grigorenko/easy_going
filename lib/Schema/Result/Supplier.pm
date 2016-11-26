use utf8;
package Schema::Result::Supplier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Supplier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<supplier>

=cut

__PACKAGE__->table("supplier");

=head1 ACCESSORS

=head2 supplier_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "supplier_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</supplier_id>

=back

=cut

__PACKAGE__->set_primary_key("supplier_id");

=head1 RELATIONS

=head2 supplier2managers

Type: has_many

Related object: L<Schema::Result::Supplier2manager>

=cut

__PACKAGE__->has_many(
  "supplier2managers",
  "Schema::Result::Supplier2manager",
  { "foreign.supplier_id" => "self.supplier_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-20 15:38:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TXYbTd1I1hvgp5XGYlUSow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
