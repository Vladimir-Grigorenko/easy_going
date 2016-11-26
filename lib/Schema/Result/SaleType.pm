use utf8;
package Schema::Result::SaleType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::SaleType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sale_type>

=cut

__PACKAGE__->table("sale_type");

=head1 ACCESSORS

=head2 saletype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "saletype_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
);

=head1 PRIMARY KEY

=over 4

=item * L</saletype_id>

=back

=cut

__PACKAGE__->set_primary_key("saletype_id");

=head1 RELATIONS

=head2 sales

Type: has_many

Related object: L<Schema::Result::Sale>

=cut

__PACKAGE__->has_many(
  "sales",
  "Schema::Result::Sale",
  { "foreign.saletype_id" => "self.saletype_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-10-19 12:25:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yxt7M6cFcFUlvXl8l/5FGw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
