use utf8;
package Schema::Result::Category2featureGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Category2featureGroup

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<category2feature_group>

=cut

__PACKAGE__->table("category2feature_group");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "category_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</category_id>

=back

=cut

__PACKAGE__->set_primary_key("category_id");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Schema::Result::Category3>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Schema::Result::Category3",
  { category_id => "category_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 feature_group

Type: belongs_to

Related object: L<Schema::Result::FeatureGroup>

=cut

__PACKAGE__->belongs_to(
  "feature_group",
  "Schema::Result::FeatureGroup",
  { feature_group_id => "feature_group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-06 12:21:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CHeRsQNGmQqMID3iH9EB7A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
