
/* vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 cc=80; */

/**
 * @package     jquery.textinplace
 * @copyright   2012 Rector and Board of Visitors, University of Virginia
 * @license     http://www.apache.org/licenses/LICENSE-2.0.html
 */

module.exports = function(grunt) {

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.initConfig({

    coffee: {

      src: {
        src: 'jquery.textinplace.coffee',
        dest: 'dist/jquery.textinplace.js'
      },

      test: {
        src: 'jquery.textinplace.spec.coffee',
        dest: 'dist/jquery.textinplace.spec.js'
      }

    },

    uglify: {

      dist: {
        src: 'dist/jquery.textinplace.js',
        dest: 'dist/jquery.textinplace.min.js'
      }

    },

    watch: {

      dist: {
        files: '*.coffee',
        tasks: 'default'
      }

    },

    jasmine: {

      dist: {
        src: 'dist/jquery.textinplace.js',
        options: {
          vendor: [
            'bower_components/jquery/jquery.js',
            'bower_components/jquery-ui/ui/jquery-ui.js'
          ],
          specs: 'dist/jquery.textinplace.spec.js'
        }
      }

    },

  });

  grunt.registerTask('default', ['coffee', 'uglify', 'jasmine']);

};
