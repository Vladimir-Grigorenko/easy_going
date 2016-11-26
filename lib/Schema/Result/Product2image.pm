use utf8;
package Schema::Result::Product2image;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Product2image

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product2image>

=cut

__PACKAGE__->table("product2image");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 image_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 image_size_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "image_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "image_size_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
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

=head2 image

Type: belongs_to

Related object: L<Schema::Result::Image>

=cut

__PACKAGE__->belongs_to(
  "image",
  "Schema::Result::Image",
  { image_id => "image_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 image_size

Type: belongs_to

Related object: L<Schema::Result::ImageSize>

=cut

__PACKAGE__->belongs_to(
  "image_size",
  "Schema::Result::ImageSize",
  { image_size_id => "image_size_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YbzeL4R3Vjgatn9Xmy2Y8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
