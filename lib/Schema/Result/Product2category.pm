use utf8;
package Schema::Result::Product2category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Product2category

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product2category>

=cut

__PACKAGE__->table("product2category");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 product_id

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
  "category_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "product_id",
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

=item * L</category_id>

=item * L</product_id>

=back

=cut

__PACKAGE__->set_primary_key("category_id", "product_id");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Schema::Result::Category3>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Schema::Result::Category3",
  { category_id => "category_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 product

Type: belongs_to

Related object: L<Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Schema::Result::Product",
  { product_id => "product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-06 12:21:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eN4V/gzkUzVQ+3ffeAoR7g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
