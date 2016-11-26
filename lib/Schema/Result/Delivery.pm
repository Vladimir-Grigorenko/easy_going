use utf8;
package Schema::Result::Delivery;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Delivery

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<delivery>

=cut

__PACKAGE__->table("delivery");

=head1 ACCESSORS

=head2 delivery_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 default_cost

  data_type: 'integer'
  default_value: 45
  extra: {unsigned => 1}
  is_nullable: 0

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 comment

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "delivery_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "default_cost",
  {
    data_type => "integer",
    default_value => 45,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "comment",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</delivery_id>

=back

=cut

__PACKAGE__->set_primary_key("delivery_id");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-20 15:38:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7PXfBgbex2bZr0Pf+e7NXw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
