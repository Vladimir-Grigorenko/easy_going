use utf8;
package Schema::Result::VProduct2feature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::VProduct2feature - VIEW

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<v_product2feature>

=cut

__PACKAGE__->table("v_product2feature");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 90

=head2 title_en

  data_type: 'varchar'
  is_nullable: 0
  size: 90

=head2 feature2value_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 default

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

0 - ???
1 - ??

=head2 value

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 sub_value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 90 },
  "title_en",
  { data_type => "varchar", is_nullable => 0, size => 90 },
  "feature2value_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "default",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "value",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "product_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "sub_value",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 45 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-23 15:20:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2HSBBKFpWyQqWKI1tSo1fg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
