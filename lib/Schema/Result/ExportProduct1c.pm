use utf8;
package Schema::Result::ExportProduct1c;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::ExportProduct1c

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<export_product_1c>

=cut

__PACKAGE__->table("export_product_1c");

=head1 ACCESSORS

=head2 export_product_1c_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
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
  "export_product_1c_id",
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

=item * L</export_product_1c_id>

=back

=cut

__PACKAGE__->set_primary_key("export_product_1c_id");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-15 11:09:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z8BAXprAf8nfmEOZkXCMtQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
