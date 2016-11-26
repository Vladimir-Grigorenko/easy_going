use utf8;
package Schema::Result::FeatureGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::FeatureGroup

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<feature_group>

=cut

__PACKAGE__->table("feature_group");

=head1 ACCESSORS

=head2 feature_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 overflow

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

0 - ?????? ?? ????? (?????????)
1 - ??????? ?? ?????

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "feature_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "overflow",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
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

=item * L</feature_group_id>

=item * L</overflow>

=back

=cut

__PACKAGE__->set_primary_key("feature_group_id", "overflow");

=head1 RELATIONS

=head2 category2feature_groups

Type: has_many

Related object: L<Schema::Result::Category2featureGroup>

=cut

__PACKAGE__->has_many(
  "category2feature_groups",
  "Schema::Result::Category2featureGroup",
  { "foreign.feature_group_id" => "self.feature_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature2group

Type: might_have

Related object: L<Schema::Result::Feature2group>

=cut

__PACKAGE__->might_have(
  "feature2group",
  "Schema::Result::Feature2group",
  { "foreign.feature_group_id" => "self.feature_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c8Gctxo0mKti8aWHpt4k9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
