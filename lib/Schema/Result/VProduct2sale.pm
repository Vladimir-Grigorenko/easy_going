use utf8;
package Schema::Result::VProduct2sale;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::VProduct2sale - VIEW

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<v_product2sale>

=cut

__PACKAGE__->table("v_product2sale");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

??? ????? ???????

=head2 depth

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 width

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 heigth

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 weight

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 quantity

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 unit_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 barcode

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 rating

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 tag_title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 tag_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 tag_keywords

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 date_update

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 category_name

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 url2site

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 instr

  data_type: 'text'
  is_nullable: 0

=head2 caterory_url

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 unit_code

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 unit_code2

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 unit_name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 sale_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "category_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "product_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "user_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "depth",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "width",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "heigth",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "weight",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "quantity",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "unit_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "barcode",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "rating",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "tag_title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "tag_description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "tag_keywords",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "date_update",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "category_name",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "url2site",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "instr",
  { data_type => "text", is_nullable => 0 },
  "caterory_url",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "unit_code",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "unit_code2",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "unit_name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "sale_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-10-19 12:25:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mxig+qpNtKaduJsohts0AQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
