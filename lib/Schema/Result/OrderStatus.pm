use utf8;
package Schema::Result::OrderStatus;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::OrderStatus

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<order_status>

=cut

__PACKAGE__->table("order_status");

=head1 ACCESSORS

=head2 order_status_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 is_auto

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "order_status_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "is_auto",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</order_status_id>

=back

=cut

__PACKAGE__->set_primary_key("order_status_id");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Schema::Result::Order",
  { "foreign.status_id" => "self.order_status_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JF6frCKBLTvtoqrNlDPkPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
