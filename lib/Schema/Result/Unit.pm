use utf8;
package Schema::Result::Unit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Unit

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<unit>

=cut

__PACKAGE__->table("unit");

=head1 ACCESSORS

=head2 unit_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 default

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 code2

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "unit_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "default",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "code",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "code2",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unit_id>

=back

=cut

__PACKAGE__->set_primary_key("unit_id");

=head1 RELATIONS

=head2 products

Type: has_many

Related object: L<Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "products",
  "Schema::Result::Product",
  { "foreign.unit_id" => "self.unit_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-08-17 13:54:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1it7tcSYF4kCZJyol2Vrpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
