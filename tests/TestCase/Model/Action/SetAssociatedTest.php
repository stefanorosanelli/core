<?php
/**
 * BEdita, API-first content management framework
 * Copyright 2016 ChannelWeb Srl, Chialab Srl
 *
 * This file is part of BEdita: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * See LICENSE.LGPL or <http://gnu.org/licenses/lgpl-3.0.html> for more details.
 */

namespace BEdita\Core\Test\TestCase\Model\Action;

use BEdita\Core\Model\Action\SetAssociated;
use Cake\ORM\Query;
use Cake\ORM\TableRegistry;
use Cake\TestSuite\TestCase;
use Cake\Utility\Inflector;

/**
 * @covers \BEdita\Core\Model\Action\SetAssociated<extended>
 */
class SetAssociatedTest extends TestCase
{

    /**
     * Fixtures
     *
     * @var array
     */
    public $fixtures = [
        'plugin.BEdita/Core.fake_animals',
        'plugin.BEdita/Core.fake_articles',
        'plugin.BEdita/Core.fake_tags',
        'plugin.BEdita/Core.fake_articles_tags',
    ];

    /**
     * {@inheritDoc}
     */
    public function setUp()
    {
        parent::setUp();

        TableRegistry::get('FakeTags')
            ->belongsToMany('FakeArticles', [
                'joinTable' => 'fake_articles_tags',
            ]);

        TableRegistry::get('FakeArticles')
            ->belongsToMany('FakeTags', [
                'joinTable' => 'fake_articles_tags',
            ])
            ->source()
            ->belongsTo('FakeAnimals');

        TableRegistry::get('FakeAnimals')
            ->hasMany('FakeArticles');
    }

    /**
     * {@inheritDoc}
     */
    public function tearDown()
    {
        TableRegistry::remove('FakeTags');
        TableRegistry::remove('FakeArticles');
        TableRegistry::remove('FakeAnimals');

        parent::tearDown();
    }

    /**
     * Data provider for `testInvocation` test case.
     *
     * @return array
     */
    public function invocationProvider()
    {
        return [
            'nothingToDo' => [
                true,
                'FakeTags',
                'FakeArticles',
                1,
                null,
            ],
            'belongsToMany' => [
                true,
                'FakeTags',
                'FakeArticles',
                1,
                1,
            ],
            'hasMany' => [
                true,
                'FakeAnimals',
                'FakeArticles',
                1,
                [1, 2],
            ],
            'unsupportedMultipleEntities' => [
                new \InvalidArgumentException(
                    'Unable to link multiple entities'
                ),
                'FakeArticles',
                'FakeAnimals',
                1,
                [1, 2],
            ],
            'belongsTo' => [
                true,
                'FakeArticles',
                'FakeAnimals',
                2,
                2,
            ],
        ];
    }

    /**
     * Test invocation of command.
     *
     * @param bool|\Exception Expected result.
     * @param string $table Table to use.
     * @param string $association Association to use.
     * @param int $entity Entity to update relations for.
     * @param int|int[]|null $related Related entity(-ies).
     * @return void
     *
     * @dataProvider invocationProvider()
     */
    public function testInvocation($expected, $table, $association, $entity, $related)
    {
        if ($expected instanceof \Exception) {
            $this->setExpectedException(get_class($expected), $expected->getMessage());
        }

        $association = TableRegistry::get($table)->association($association);
        $action = new SetAssociated($association);

        $entity = $association->source()->get($entity, ['contain' => [$association->name()]]);
        $relatedEntities = null;
        if (is_int($related)) {
            $relatedEntities = $association->target()->get($related);
        } elseif (is_array($related)) {
            $relatedEntities = $association->target()->find()
                ->where([
                    $association->target()->primaryKey() . ' IN' => $related,
                ])
                ->toArray();
        }

        $result = $action($entity, $relatedEntities);

        $count = 0;
        if ($related !== null) {
            $count = $association->target()->find()
                ->matching(
                    Inflector::camelize($association->source()->table()),
                    function (Query $query) use ($association, $entity) {
                        return $query->where([
                            $association->source()->aliasField($association->source()->primaryKey()) => $entity->id,
                        ]);
                    }
                )
                ->count();
        }

        $this->assertEquals($expected, $result);
        $this->assertEquals(count($related), $count);
    }
}
