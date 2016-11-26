use utf8;
package Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Product

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product>

=cut

__PACKAGE__->table("product");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  is_foreign_key: 1
  is_nullable: 0

=head2 rating

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 barcode

  data_type: 'varchar'
  is_nullable: 0
  size: 32

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
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 date_update

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
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
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "rating",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "barcode",
  { data_type => "varchar", is_nullable => 0, size => 32 },
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
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "date_update",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_id>

=back

=cut

__PACKAGE__->set_primary_key("product_id");

=head1 RELATIONS

=head2 export_product_1cs

Type: has_many

Related object: L<Schema::Result::ExportProduct1c>

=cut

__PACKAGE__->has_many(
  "export_product_1cs",
  "Schema::Result::ExportProduct1c",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 image2products

Type: has_many

Related object: L<Schema::Result::Image2product>

=cut

__PACKAGE__->has_many(
  "image2products",
  "Schema::Result::Image2product",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product2categories

Type: has_many

Related object: L<Schema::Result::Product2category>

=cut

__PACKAGE__->has_many(
  "product2categories",
  "Schema::Result::Product2category",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product2feature2values

Type: has_many

Related object: L<Schema::Result::Product2feature2value>

=cut

__PACKAGE__->has_many(
  "product2feature2values",
  "Schema::Result::Product2feature2value",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product2sales

Type: has_many

Related object: L<Schema::Result::Product2sale>

=cut

__PACKAGE__->has_many(
  "product2sales",
  "Schema::Result::Product2sale",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_price

Type: might_have

Related object: L<Schema::Result::ProductPrice>

=cut

__PACKAGE__->might_have(
  "product_price",
  "Schema::Result::ProductPrice",
  { "foreign.product_id" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit

Type: belongs_to

Related object: L<Schema::Result::Unit>

=cut

__PACKAGE__->belongs_to(
  "unit",
  "Schema::Result::Unit",
  { unit_id => "unit_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 update_product_1cs

Type: has_many

Related object: L<Schema::Result::UpdateProduct1c>

=cut

__PACKAGE__->has_many(
  "update_product_1cs",
  "Schema::Result::UpdateProduct1c",
  { "foreign.product_id" => "self.product_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-15 11:09:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pCHlkknl1OvDsiVYaNXPOw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
