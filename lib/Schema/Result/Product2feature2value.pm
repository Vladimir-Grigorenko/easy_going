use utf8;
package Schema::Result::Product2feature2value;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Product2feature2value

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product2feature2value>

=cut

__PACKAGE__->table("product2feature2value");

=head1 ACCESSORS

=head2 product2feature2value_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature2value_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 sub_value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "product2feature2value_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "product_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature2value_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "sub_value",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product2feature2value_id>

=back

=cut

__PACKAGE__->set_primary_key("product2feature2value_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<product_id_UNIQUE>

=over 4

=item * L</product_id>

=item * L</feature2value_id>

=back

=cut

__PACKAGE__->add_unique_constraint("product_id_UNIQUE", ["product_id", "feature2value_id"]);

=head1 RELATIONS

=head2 feature2value

Type: belongs_to

Related object: L<Schema::Result::Feature2value>

=cut

__PACKAGE__->belongs_to(
  "feature2value",
  "Schema::Result::Feature2value",
  { feature2value_id => "feature2value_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-29 14:53:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/b7yLijq9zGi+zMzQ+z71Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
