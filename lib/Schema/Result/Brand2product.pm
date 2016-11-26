use utf8;
package Schema::Result::Brand2product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Brand2product

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<brand2product>

=cut

__PACKAGE__->table("brand2product");

=head1 ACCESSORS

=head2 brand2product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 brand_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "brand2product_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "product_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "brand_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "user_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
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

=item * L</brand2product_id>

=back

=cut

__PACKAGE__->set_primary_key("brand2product_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-08-17 13:54:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1ZfYRpzPMVXsLMprSn4Y5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
