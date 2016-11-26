use utf8;
package Schema::Result::Order2product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Order2product

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<order2product>

=cut

__PACKAGE__->table("order2product");

=head1 ACCESSORS

=head2 order_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 status_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

1 - ?? ?????????????
2 - ?????????????
3 - ??????

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 500

??? ????????????????

=head2 price

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 price_usd

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 price_eur

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=cut

__PACKAGE__->add_columns(
  "order_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "product_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "status_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "price",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "price_usd",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "price_eur",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</order_id>

=back

=cut

__PACKAGE__->set_primary_key("order_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BT3/dmBGqoafc6Nzkoz1OQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
